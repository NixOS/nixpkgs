{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "matrix-hook";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "pinpox";
    repo = "matrix-hook";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YmDsibVlAWLEG5QcqDImVb6RJfrfW6zrFnOEMO3Zxcw=";
  };
  vendorHash = "sha256-185Wz9IpJRBmunl+KGj/iy37YeszbT3UYzyk9V994oQ=";
  postInstall = ''
    install message.html.tmpl -Dt $out
  '';

  meta = {
    description = "Simple webhook for matrix";
    mainProgram = "matrix-hook";
    homepage = "https://github.com/pinpox/matrix-hook";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      pinpox
      mic92
      zowoq
    ];
  };
})
