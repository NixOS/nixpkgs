{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matrix-hook";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "matrix-hook";
    rev = "v${version}";
    hash = "sha256-YmDsibVlAWLEG5QcqDImVb6RJfrfW6zrFnOEMO3Zxcw=";
  };
  vendorHash = "sha256-185Wz9IpJRBmunl+KGj/iy37YeszbT3UYzyk9V994oQ=";
  postInstall = ''
    install message.html.tmpl -Dt $out
  '';

  meta = with lib; {
    description = "A simple webhook for matrix";
    homepage = "https://github.com/pinpox/matrix-hook";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pinpox mic92 zowoq ];
  };
}
