{ stdenv, fetchFromGitHub }:

 /*
 This derivation is impure: it relies on an Xcode toolchain being installed
 and available in the expected place. The values of sandboxProfile
 are copied pretty directly from the MacVim derivation, which
 is also impure. In order to build you at least need the `sandbox`
 option set to `relaxed` or `false`.
 */

stdenv.mkDerivation rec {
  pname = "iterm2";
  version = "3.3.9";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2";
    rev = "v${version}";
    sha256 = "06mq3gfjgy8jw2f3fzdsi3pbfkdijfzzlhlw6ixa5bfb4hbcgn5j";
  };

  patches = [ ./disable_updates.patch ];
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

  meta = with stdenv.lib; {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tricktron ];
    platforms = platforms.darwin;
    hydraPlatforms = [];
  };
}
