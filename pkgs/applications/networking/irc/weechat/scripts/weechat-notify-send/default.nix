{ lib, stdenv, fetchFromGitHub, libnotify }:

stdenv.mkDerivation rec {
  pname = "weechat-notify-send";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "s3rvac";
    repo = pname;
    rev = "v${version}";
    sha256 = "1693b7axm9ls5p7hm6kq6avddsisi491khr5irvswr5lpizvys6a";
  };

  passthru.scripts = [ "notify_send.py" ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    install -D notify_send.py $out/share/notify_send.py
    substituteInPlace $out/share/notify_send.py \
      --replace "'notify-send'" "'${libnotify}/bin/notify-send'"
  '';

  meta = with lib; {
    description = "A WeeChat script that sends highlight and message notifications through notify-send";
    homepage = "https://github.com/s3rvac/weechat-notify-send";
    license = licenses.mit;
    maintainers = with maintainers; [ tobim ];
  };
}
