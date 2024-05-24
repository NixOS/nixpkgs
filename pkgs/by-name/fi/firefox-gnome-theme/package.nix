{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttr: {
  pname = "firefox-gnome-theme";
  version = "126";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v${finalAttr.version}";
    hash = "sha256-jVbj2JD5GRkP8s3vKBtd9PDpftf3kjLR0ZA/ND/c2+Q=";
  };

  outputs = [ "out" "doc" ];

  strictDeps = true;

  # Only copy necessary files
  installPhase = ''
    runHook preInstall

    install -d $out
    cp -ra ./configuration ./theme ./icon.svg ./userChrome.css ./userContent.css -t $out
    install -Dm 644 ./README.md -t $doc/share/doc/firefox-gnome-theme/

    runHook postInstall
  '';

  meta = {
    description = "A GNOME theme for Firefox";
    longDescription = ''
      A GNOME theme for Firefox.
      This theme follows latest GNOME Adwaita style.
    '';
    homepage = "https://github.com/rafaelmardojai/firefox-gnome-theme";
    downloadPage = "https://github.com/rafaelmardojai/firefox-gnome-theme/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.all;
  };
})
