{
  lib,
  stdenv,
  fetchFromGitHub,
  libnotify,
}:

stdenv.mkDerivation rec {
  pname = "weechat-notify-send";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "s3rvac";
    repo = "weechat-notify-send";
    rev = "v${version}";
    sha256 = "sha256-a1wRFHJB6avYWdSVAz5Mxd3XEzM8oHs0b5quK93RJm0=";
  };

  passthru.scripts = [ "notify_send.py" ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    install -D notify_send.py $out/share/notify_send.py
    substituteInPlace $out/share/notify_send.py \
      --replace "'notify-send'" "'${libnotify}/bin/notify-send'"
  '';

  meta = {
    description = "WeeChat script that sends highlight and message notifications through notify-send";
    homepage = "https://github.com/s3rvac/weechat-notify-send";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tobim ];
  };
}
