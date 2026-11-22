{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gotools,
}:

buildGoModule (finalAttrs: {
  pname = "jobber";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "dshearer";
    repo = "jobber";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mLYyrscvT/VK9ehwkPUq4RbwHb+6Wjvt7ZXk/fI0HT4=";
  };

  vendorHash = null;

  nativeBuildInputs = [ gotools ];

  postConfigure = "go generate ./...";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dshearer/jobber/common.jobberVersion=${finalAttrs.version}"
    "-X github.com/dshearer/jobber/common.etcDirPath=${placeholder "out"}/etc"
  ];

  postInstall = ''
    mkdir -p $out/etc $out/libexec
    $out/bin/jobbermaster defprefs --libexec $out/libexec > $out/etc/jobber.conf
    mv $out/bin/jobber{master,runner} $out/libexec/
  '';

  meta = {
    homepage = "https://dshearer.github.io/jobber";
    changelog = "https://github.com/dshearer/jobber/releases/tag/v${finalAttrs.version}";
    description = "Alternative to cron, with sophisticated status-reporting and error-handling";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jobber";
  };
})
