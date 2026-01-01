{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

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

<<<<<<< HEAD
  meta = {
    description = "Simple webhook for matrix";
    mainProgram = "matrix-hook";
    homepage = "https://github.com/pinpox/matrix-hook";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Simple webhook for matrix";
    mainProgram = "matrix-hook";
    homepage = "https://github.com/pinpox/matrix-hook";
    license = licenses.gpl3;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pinpox
      mic92
      zowoq
    ];
  };
}
