{
  stdenv,
  fetchurl,
  undmg,
  meta,
  pname,
  version,
  rev,
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://installers.lmstudio.ai/darwin/arm64/${version}-${rev}/LM-Studio-${version}-${rev}-arm64.dmg";
    hash = "sha256-x4IRT1PjBz9eafmwNRyLVq+4/Rkptz6RVWDFdRrGnGY=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  # LM Studio ships Scripts inside the App Bundle, which may be messed up by standard fixups
  dontFixup = true;

  # undmg doesn't support APFS and 7zz does break the xattr. Took that approach from https://github.com/NixOS/nixpkgs/blob/a3c6ed7ad2649c1a55ffd94f7747e3176053b833/pkgs/by-name/in/insomnia/package.nix#L52
  unpackCmd = ''
    echo "Creating temp directory"
    mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
    function finish {
      echo "Ejecting temp directory"
      /usr/bin/hdiutil detach $mnt -force
      rm -rf $mnt
    }
    # Detach volume when receiving SIG "0"
    trap finish EXIT
    # Mount DMG file
    echo "Mounting DMG file into \"$mnt\""
    /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt $curSrc
    # Copy content to local dir for later use
    echo 'Copying extracted content into "sourceRoot"'
    cp -a $mnt/LM\ Studio.app $PWD/
  '';
}
