{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hd-idle";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "adelolmo";
    repo = "hd-idle";
    rev = "v${version}";
    sha256 = "sha256-WHJcysTN9LHI1WnDuFGTyTirxXirpLpJIeNDj4sZGY0=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage debian/hd-idle.8
  '';

  meta = with lib; {
    description = "Spins down external disks after a period of idle time";
    mainProgram = "hd-idle";
    homepage = "https://github.com/adelolmo/hd-idle";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rycee ];
  };
}
