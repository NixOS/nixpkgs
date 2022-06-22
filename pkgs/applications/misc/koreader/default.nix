{ lib
, stdenv
, fetchurl
, fetchgit
, fetchFromGitHub
, git
, pkgconfig
, cmake
, coreutils
, autoconf
, automake
, libtool
, lua51Packages
, perl
, which
, python27
, python3
, glib
, gnutar
, gtk3-x11
, sdcv
, SDL2
, patchelf
, makeWrapper
}:

let
  pname = "koreader";
  version = "2022.05.1";

  luaPackages = lua51Packages; # must match version vendored within koreader
  luarocks = luaPackages.luarocks;

  # Maybe this should go in lib/attrs.nix?
  mapAttrsToConcatStringSep = sep: func: val:
    lib.concatStringsSep sep (lib.mapAttrsToList func val);

  # Maybe this should go in `buildLuaRocksPackage` as a `passthru`?
  # This assembles a `.rock` from lua package, allowing it to be
  # reinstalled in the local "tree" used during koreader's build
  # process.
  buildLuaRockPackage = luaPackage:
     luaPackage.overrideAttrs (oa: {
        postInstall = ''
          $LUAROCKS pack --tree=$out ${oa.pname}
          rm -rf $out
          mkdir -p $out
          mv *.rock $out/
          '' + oa.postInstall or "";
      });

  vendoredLuaRockPackages = lib.lists.map buildLuaRockPackage [
    luaPackages.lpeg
    luaPackages.luajson
  ];

  # Read the hand-maintained data in the vendored.nix file, then add
  # additional attrs (isGit, dest, fetched) computed therefrom.
  vendored = lib.mapAttrs (name: attrs:
    with attrs;
    let
      isGit = attrs?tag || attrs?rev;
      dest = if isGit
             then "base/thirdparty/${name}/build/git_checkout/${name}"
             else "base/thirdparty/${name}/build/downloads/${filename}";
      fetched =
        if isGit
        then fetchgit {
          inherit (attrs) url hash;
          rev = attrs.rev or "refs/tags/${attrs.tag}";
        }
        else fetchurl {
          inherit (attrs) url hash;
        };
    in attrs // { inherit isGit dest fetched; })
    (import ./vendored.nix);

  # Any valid git tag name can be used here (see `postPatch`).
  placeholder-git-tag = "nixpkgs-placeholder-git-tag";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "koreader";
    repo = "koreader";
    rev = "v${version}";
    hash = "sha256-ndVbuL2kspyv5FSBwdAEJEKR9xBh/VbTuC6tHOQqXc0=";
    fetchSubmodules = true;
  };

  postUnpack =
    mapAttrsToConcatStringSep "\n"
      (name: attrs:
        with attrs;
        # Fetch vendored deps and put them where koreader expects.
        ''
        mkdir -p $(dirname $sourceRoot/${dest})
        cp -ar ${fetched} $sourceRoot/${dest}
        chmod -R u+w $sourceRoot/${dest}
        ''
        # see `postPatch` for why this substitution is performed
        + lib.optionalString (attrs?rev) ''
        substituteInPlace \
          $sourceRoot/base/thirdparty/${name}/CMakeLists.txt \
          --replace ${rev} ${placeholder-git-tag}
        ''
      )
      vendored;

  # the usual /usr/bin/env headaches...
  prePatch = ''
    for A in \
      openssl/build/git_checkout/openssl/config \
      glib/build/git_checkout/glib/glib/gtester-report.in \
      glib/build/git_checkout/glib/gobject/glib-mkenums.in \
      glib/build/git_checkout/glib/gobject/tests/taptestrunner.py \
      glib/build/git_checkout/glib/gobject/glib-genmarshal.in \
      glib/build/git_checkout/glib/gio/gio-querymodules-wrapper.py \
      glib/build/git_checkout/glib/gio/tests/gengiotypefuncs.py \
      glib/build/git_checkout/glib/gio/gdbus-2.0/codegen/gdbus-codegen.in \
      ; do substituteInPlace base/thirdparty/$A \
           --replace \
             /usr/bin/env \
             ${coreutils}/bin/env \
      ; done

    # when setting --libdir explicitly, newer libtools like nixpkgs'
    # expect a trailing slash; otherwise you get "cannot install...to
    # a directory not ending in"
    substituteInPlace \
      base/thirdparty/harfbuzz/CMakeLists.txt \
      --replace \
        BINARY_DIR}/lib   \
        BINARY_DIR}/lib/

    # All projects are downloaded using ko_write_gitclone_script --
    # except sdcv, which uses download_project, so it needs special
    # handling.
    substituteInPlace \
      base/thirdparty/sdcv/CMakeLists.txt \
      --replace \
        ${vendored.sdcv.url} \
        '${"$"}{CMAKE_BINARY_DIR}/../git_checkout/sdcv'
    ''
  ;

  # For projects fetched by tag reference, koreader expects to find
  # the fetched tag in the local clone; if it doesn't, it will try
  # to fetch from the origin which accesses the network.  These tags
  # will be missing because fetchgit must delete all git tags when
  # cloning in order to give deterministic results.
  #
  # Therefore we create a commit (which includes any modifications
  # made to the subproject in the `prePatch` phase) and a tag at
  # that commit.  For cloned-by-tag repositories we create a tag
  # with the expected name; for cloned-by-hash repositories we
  # create a tag named ${placeholder-git-tag}, which is
  # substitute(d)InPlace for the hash in the CMakeLists.txt during the
  # `postUnpack` phase.
  postPatch =
    mapAttrsToConcatStringSep "\n"
      (name: attrs: lib.optionalString (attrs.isGit) ''
        git -C ${attrs.dest} init
        git -C ${attrs.dest} config --local user.email "you@example.com"
        git -C ${attrs.dest} config --local user.name  "Your Name"
        git -C ${attrs.dest} add -A
        git -C ${attrs.dest} commit --quiet -m postPatch || true
        git -C ${attrs.dest} tag -f ${attrs.tag or placeholder-git-tag}
        '')
      vendored;

  nativeBuildInputs = [
    git
    cmake
    autoconf
    automake
    libtool
    pkgconfig
    which
    perl
    coreutils
    luarocks
    python27
    python3
    makeWrapper
  ];

  buildInputs = [
    gtk3-x11
    SDL2
    glib
    luaPackages.luajson
  ];

  dontUseCmakeConfigure = true;

  # nativeBuildInputs=[cmake] enables this; we must re-disable it
  enableParallelBuilding = false;

  preBuild =
    lib.strings.concatMapStringsSep "\n"
      (pkg: ''
        ${luarocks}/bin/luarocks install \
          --tree=base/build/$(${stdenv.cc}/bin/cc -dumpmachine)/rocks \
          ${pkg}/*.rock
        '')
      vendoredLuaRockPackages;

  makeFlags = [
    "PARALLEL_JOBS=$NIX_BUILD_CORES"
    "IS_RELEASE=1"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out

    mkdir -p $out/share/{applications,pixmaps,man/man1}
    cp platform/debian/koreader.desktop $out/share/applications/
    cp platform/debian/koreader.1       $out/share/man/man1/
    cp resources/koreader.png           $out/share/pixmaps/

    mkdir -p $out/bin
    cp platform/debian/koreader.sh $out/bin/koreader
    patchShebangs $out/bin/koreader

    mkdir -p $out/lib
    cp -rL koreader-emulator-$(${stdenv.cc}/bin/cc -dumpmachine)/koreader \
      $out/lib/koreader
    ${patchelf}/bin/patchelf --add-rpath $out/lib/koreader/libs/ \
      $out/lib/koreader/libs/*.so*
    ${patchelf}/bin/patchelf --allowed-rpath-prefixes /nix/store \
      --shrink-rpath $out/lib/koreader/libs/*.so*

    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ gtk3-x11 SDL2 glib ]
    }

    # ideally this should be the output of:
    # git describe HEAD | xargs git show -s --format=format:"%cd" --date=short
    echo "v${version}" > $out/lib/koreader/git-rev

    runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader supporting PDF, DjVu, EPUB, FB2 and other formats";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz amjoseph ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
