{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "url_hint";
  version = "0.8";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/10671d785ea3f9619d0afd0d7a1158bfa4ee3938/python/url_hint.py";
    hash = "sha256-Ws9BJvs6kEO4yF0MMQb6C7SBqKGu0dkWBhB7cvBMhSs=";
  };

  dontUnpack = true;

  passthru.scripts = [ "url_hint.py" ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/share/url_hint.py
    runHook postInstall
  '';

  meta = {
    inherit (weechat.meta) platforms;
    description = "WeeChat URL opening script";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eraserhd ];
  };
}
