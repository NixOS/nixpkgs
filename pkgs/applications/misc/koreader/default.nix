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
, luajit
, luarocks
, luaPackages
, perl
, which
, python27
, python3
, glib
, gnutar
, gtk3-x11
, sdcv
, SDL2
}:
let

  # maybe this should go in lib/attrs.nix?
  mapAttrsToConcatStringSep = sep: func: val:
    lib.concatStringsSep sep (lib.mapAttrsToList func val);

  # This reassembles a `.src.rock` from an installed lua package, so
  # it can be reinstalled in the local "tree" used during koreader's
  # build process.
  # maybe this should go in `buildLuaRocksPackage` as a `passthru`?
  makeSourceRock = luaPackageName:
     luaPackages.${luaPackageName}.overrideAttrs (oa: {
        postInstall = ''
          $LUAROCKS pack --tree=$out ${oa.pname}
          rm -rf $out
          mkdir -p $out
          mv *.rock $out/
          '';
      });

  luaPackages_lpeg_src_rock    = makeSourceRock "lpeg";
  luaPackages_luajson_src_rock = makeSourceRock "luajson";

  # read the vendored.nix file and add additional attrs which can be
  # computed from those which are hand-maintained (see vendored.nix)
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
          #leaveDotGit = true;   # can't use this due to https://github.com/NixOS/nixpkgs/issues/8567
          rev = attrs.rev or "refs/tags/${attrs.tag}";
        }
        else fetchurl {
          inherit (attrs) url hash;
        };
    in attrs // { inherit isGit dest fetched; })
    (import ./vendored.nix);

  pname = "koreader";
  version = "2022.05.1";

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
    # fetch the vendored deps and put them where koreader expects them to be
    mapAttrsToConcatStringSep "\n"
      (name: attrs: with attrs; ''
        mkdir -p $(dirname $sourceRoot/${dest})
        cp -ar ${fetched} $sourceRoot/${dest}
        chmod -R u+w $sourceRoot/${dest}
        '')
      vendored;

  prePatch = ''
    substituteInPlace \
      base/thirdparty/openssl/build/git_checkout/openssl/config \
      --replace /usr/bin/env ${coreutils}/bin/env

    # when setting --libdir explicitly, newer libtools like nixpkgs'
    # expect a trailing slash; otherwise you get "cannot install...to
    # a directory not ending in"
    substituteInPlace \
      base/thirdparty/harfbuzz/CMakeLists.txt \
      --replace BINARY_DIR}/lib BINARY_DIR}/lib/

    for A in \
      base/thirdparty/glib/build/git_checkout/glib/gobject/glib-mkenums.in \
      base/thirdparty/glib/build/git_checkout/glib/glib/gtester-report.in \
      base/thirdparty/glib/build/git_checkout/glib/gobject/tests/taptestrunner.py \
      base/thirdparty/glib/build/git_checkout/glib/gio/gio-querymodules-wrapper.py \
      base/thirdparty/glib/build/git_checkout/glib/gio/tests/gengiotypefuncs.py \
      base/thirdparty/glib/build/git_checkout/glib/gio/gdbus-2.0/codegen/gdbus-codegen.in \
      base/thirdparty/glib/build/git_checkout/glib/gobject/glib-mkenums.in \
      base/thirdparty/glib/build/git_checkout/glib/gobject/glib-genmarshal.in \
      ; do substituteInPlace $A --replace /usr/bin/env ${coreutils}/bin/env; done
    '';

  patches = [

    # we can't use leaveDotGit=true because the .git/ directory's
    # packing is not deterministic (see
    # https://github.com/NixOS/nixpkgs/issues/8567).  So instead we
    # patch koreader to use the default branch of our clones.  Note
    # that if upstream changes the commits, this patch will fail to
    # apply (which we want), and we will notice that adjustment is
    # needed.
    ./patches/eliminate-commit-hashes.patch

    # koreader's build scripts silently delete uncommitted changes
    #./patches/dont-obliterate-uncommitted-stuff.patch

    # koreader vendors lua, but does not vendor luarocks, so headaches
    # arise if the non-vendored luarocks is not based on exactly the
    # same version of lua as the one which is vendored.
    ./patches/do-not-override-lua-paths.patch

    # omit lua-Spore from the build.  this is obviously unacceptable
    # for merging, but at the moment it can't find luajson, and I
    # can't seem to get the build process to use the one from nixpkgs.
    #./patches/omit-lua-spore.patch

    # unlike all the other vendored projects, sdcv is downloaded using
    # download_project rather than ko_write_gitclone_script, so it
    # requires a different approach.
    ./patches/redirect-sdcv.patch
  ];

  postPatch =
    # Koreader expects to find the fetched tag in the local clone; if
    # it doesn't, it will try to fetch from the origin.  Fetchgit does
    # not fetch git tags when cloning a repo, since the set of tags
    # delivered by 'git clone' is not covered by the commit hash and
    # will change over time as upstream adds/removes tags.  So we must
    # manually recreate the tag that koreader expects to find.
    #
    # Before creating the tag, we add a commit for any uncommitted
    # changes which may have been created by the prePatch and patch
    # phases above.  This is why the tag-creation step can happen no
    # earlier than postPatch.
    #
    # Note: we can apply patches only to the vendored dependencies
    # which koreader references by tag rather than by commit-hash --
    # unless we patch the commit-hash in koreader's cmake files.
    mapAttrsToConcatStringSep "\n"
      (name: attrs: lib.optionalString (attrs.isGit) ''
        git -C ${attrs.dest} init
        git -C ${attrs.dest} config --local user.email "you@example.com"
        git -C ${attrs.dest} config --local user.name  "Your Name"
        git -C ${attrs.dest} add -A
        git -C ${attrs.dest} commit --quiet -m postPatch || true
        git -C ${attrs.dest} tag -f ${attrs.tag or "nixpkgs-tag"}
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
  ];

  buildInputs = [
    glib
    luajit
    gnutar
    gtk3-x11
    sdcv
    SDL2
    luaPackages.luajson
    luaPackages_lpeg_src_rock
    luaPackages_luajson_src_rock
  ];

  dontUseCmakeConfigure = true;
  dontUseCmakeBuildDir = true;

  # nativeBuildInputs=[cmake] enables this; we must re-disable it
  enableParallelBuilding = false;

  preBuild = ''
    ${luarocks}/bin/luarocks install --tree=base/build/${MACHINE}/rocks ${luaPackages_lpeg_src_rock}/*.rock
    ${luarocks}/bin/luarocks install --tree=base/build/${MACHINE}/rocks ${luaPackages_luajson_src_rock}/*.rock
    '';

  makeFlags = [
    "PARALLEL_JOBS=$NIX_BUILD_CORES"
    "IS_RELEASE=1"
  ];

  # koreader does not have a separate `make install` target
  installPhase = ''
    mkdir -p $out

    mkdir -p $out/share/{applications,pixmaps,man/man1}
    cp platform/debian/koreader.desktop $out/share/applications/
    cp resources/koreader.png $out/share/pixmaps/
    cp platform/debian/koreader.1 $out/share/man/man1

    mkdir -p $out/bin
    cp platform/debian/koreader.sh $out/bin/koreader
    patchShebangs $out/bin/koreader

    mkdir -p $out/lib
    cp -rL koreader-emulator-$(${stdenv.cc}/bin/cc -dumpmachine)/koreader $out/lib/koreader
    '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz amjoseph ];
    sourceProvenance = [ ];
  };
}
