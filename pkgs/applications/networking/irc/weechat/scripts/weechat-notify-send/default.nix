{ lib, stdenv, fetchFromGitHub, libnotify }:

stdenv.mkDerivation rec {
  pname = "weechat-notify-send";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "s3rvac";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7uw0IdRSxhPrLqdgECKB9eOrtFj+2HTILBhakKiRuNQ=";
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
