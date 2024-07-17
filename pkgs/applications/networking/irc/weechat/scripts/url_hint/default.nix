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
    sha256 = "0aw59kq74yqh0qbdkldfl6l83d0bz833232xr2w4741szck43kss";
  };

  dontUnpack = true;

  passthru.scripts = [ "url_hint.py" ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/share/url_hint.py
    runHook postInstall
  '';

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "url_hint.py is a URL opening script.";
    license = licenses.mit;
    maintainers = with maintainers; [ eraserhd ];
  };
}
