{
  lib,
  stdenv,
  fetchFromGitHub,
  writeScript,
  common-updater-scripts,
  coreutils,
  git,
  gnused,
  nix,
}:

let
  owner = "scopatz";
  repo = "nanorc";
in
stdenv.mkDerivation rec {
  pname = "nanorc";
  version = "2020-10-10";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = builtins.replaceStrings [ "-" ] [ "." ] version;
    sha256 = "3B2nNFYkwYHCX6pQz/hMO/rnVqlCiw1BSNmGmJ6KCqE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share

    install *.nanorc $out/share/
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!${stdenv.shell}
    set -o errexit
    PATH=${
      lib.makeBinPath [
        common-updater-scripts
        coreutils
        git
        gnused
        nix
      ]
    }
    oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion ${pname}" | tr -d '"' | sed 's|\\.|-|g')"
    latestTag="$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs --sort='version:refname' --tags git@github.com:${owner}/${repo} '*.*.*' | tail --lines=1 | cut --delimiter='/' --fields=3)"
    if [ "$oldVersion" != "$latestTag" ]; then
      nixpkgs="$(git rev-parse --show-toplevel)"
      default_nix="$nixpkgs/pkgs/applications/editors/nano/nanorc/default.nix"
      newTag=$(echo $latestTag | sed 's|\.|-|g')
      update-source-version ${pname} "$newTag" --version-key=version --print-changes
    else
      echo "${pname} is already up-to-date"
    fi
  '';

  meta = {
    description = "Improved Nano Syntax Highlighting Files";
    homepage = "https://github.com/scopatz/nanorc";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}
