{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "iterm2-${version}";
  version = "3.0.14";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2";
    rev = "v${version}";
    sha256 = "03m0ja11w9910z96yi8fzq3436y8xl14q031rdb2w3sapjd54qrj";
  };

  patches = [ ./disable_updates.patch ];
  postPatch = ''
    sed -i -e 's/CODE_SIGN_IDENTITY = "Developer ID Application"/CODE_SIGN_IDENTITY = ""/g' ./iTerm2.xcodeproj/project.pbxproj
  '';
  makeFlagsArray = ["Deployment"];
  installPhase = ''
    mkdir -p "$out/Applications"
    mv "build/Deployment/iTerm2.app" "$out/Applications/iTerm.app"
  '';

  meta = {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.darwin;
  };
}
