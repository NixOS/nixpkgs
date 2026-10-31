{
  lib,
  stdenv,
  fetchFromGitHub,
  weechat,
}:

stdenv.mkDerivation rec {
  pname = "edit-weechat";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "keith";
    repo = "edit-weechat";
    rev = version;
    hash = "sha256-3Bgd0ueiQYfhGHyUxwyNIalGN6lsCLayuRTODijIgug=";
  };

  dontBuild = true;

  passthru.scripts = [ "edit.py" ];

  installPhase = ''
    runHook preInstall
    install -D edit.py $out/share/edit.py
    runHook postInstall
  '';

  meta = {
    inherit (weechat.meta) platforms;
    description = "This simple weechat plugin allows you to compose messages in your $EDITOR";
    homepage = "https://github.com/keith/edit-weechat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eraserhd ];
  };
}
