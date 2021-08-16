{ lib, stdenv, fetchFromGitHub }:

 /*
 This derivation is impure: it relies on an Xcode toolchain being installed
 and available in the expected place. The values of sandboxProfile
 are copied pretty directly from the MacVim derivation, which
 is also impure. In order to build you at least need the `sandbox`
 option set to `relaxed` or `false`.
 */

stdenv.mkDerivation rec {
  pname = "iterm2";
  version = "3.4.8";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2";
    rev = "v${version}";
    sha256 = "sha256-7nhlg5BBudfa0hWtnHx4aujWpOLv6ByrUKmo+nqtb2M=";
  };

  patches = [
    ./disable_updates.patch

    # v3.4.5 cannot build but v3.4.4 can,
    # revert 2a4869a54e49f7b43b599a0b461b8f9a5fa5eed1 from git bisect.
    ./0001-Revert-Fix-installing-delta-updates-of-runtime.patch
   ];
  postPatch = ''
    sed -i -e 's/CODE_SIGN_IDENTITY = "Developer ID Application"/CODE_SIGN_IDENTITY = ""/g' ./iTerm2.xcodeproj/project.pbxproj
  '';

  preConfigure = "LD=$CC";
  makeFlagsArray = ["Nix"];
  installPhase = ''
    mkdir -p $out/Applications
    mv Build/Products/Deployment/iTerm2.app $out/Applications/iTerm.app
  '';

  sandboxProfile = ''
     (allow file-read* file-write* process-exec mach-lookup)
     ; block homebrew dependencies
     (deny file-read* file-write* process-exec mach-lookup (subpath "/usr/local") (with no-log))
  '';

  meta = with lib; {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = "https://www.iterm2.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tricktron ];
    platforms = [ "x86_64-darwin" ];
    hydraPlatforms = [];
  };
}
