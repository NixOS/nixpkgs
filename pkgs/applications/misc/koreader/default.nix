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
, glib
, gnutar
, gtk3-x11
, sdcv
, SDL2
, nerdfonts
}:
let

  # maybe this should go in lib/attrs.nix?
  mapAttrsToConcatStringSep = sep: func: val:
    lib.concatStringsSep sep (lib.mapAttrsToList func val);

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
          leaveDotGit = true;
          rev = attrs.rev or "refs/tags/${attrs.tag}";
        }
        else fetchurl {
          inherit (attrs) url hash;
        };
    in attrs // { inherit isGit dest fetched; })
    (import ./vendored.nix);

  fonts = import ./fonts.nix { inherit lib fetchurl nerdfonts; };

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
    '';

  patches = [
    # koreader's build scripts silently delete uncommitted changes
    ./patches/dont-obliterate-uncommitted-stuff.patch

    # koreader vendors lua, but does not vendor luarocks, so headaches
    # arise if the non-vendored luarocks is not based on exactly the
    # same version of lua as the one which is vendored.
    ./patches/do-not-override-lua-paths.patch

    # omit lua-Spore from the build.  this is obviously unacceptable
    # for merging, but at the moment it can't find luajson, and I
    # can't seem to get the build process to use the one from nixpkgs.
    ./patches/omit-lua-spore.patch
  ];

  postPatch =
    # Fetchgit does not fetch git tags when cloning a repo, since the
    # set of tags delivered by 'git clone' is not covered by the
    # commit hash and will change over time as upstream adds/removes
    # tags.  However koreader expects to find the fetched tag in the
    # local clone; if it doesn't, it will try to fetch from the
    # origin.  So we recreate the tag.  Before doing so we add a
    # commit for any uncommitted changes created in the prePatch and
    # patch phases above.
    #
    # This cannot be done earlier than postPatch because the patching
    # will change the tag's commit.
    #
    # Note that we cannot apply patches to any of the vendored
    # dependencies which koreader references by commit-hash -- unless
    # we patch the commit-hash in koreader's cmake files.  Only the
    # tag-referenced dependencies are malleable.
    mapAttrsToConcatStringSep "\n"
      (name: attrs: lib.optionalString (attrs?tag) ''
        git -C ${attrs.dest} config --local user.email "you@example.com"
        git -C ${attrs.dest} config --local user.name  "Your Name"
        git -C ${attrs.dest} add -A
        git -C ${attrs.dest} commit -m postPatch || true
        git -C ${attrs.dest} tag -f ${attrs.tag}
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
  ];

  buildInputs = [
    glib
    luajit
    gnutar
    gtk3-x11
    sdcv
    SDL2
    luaPackages.luajson
  ];

  dontUseCmakeConfigure = true;
  dontUseCmakeBuildDir = true;

  makeFlags = [
    "PARALLEL_JOBS=$NIX_BUILD_CORES"
  ];

  # koreader does not have a separate `make install` target
  installPhase = fonts.installPhase;

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz amjoseph ];
    sourceProvenance = [ ];
  };
}
