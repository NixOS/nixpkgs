{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "norouter";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "norouter";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EY/Yfyaz2DeQKHJ4awpQDbrVkse9crIZlLzfviPy3Tk=";
  };

  vendorHash = "sha256-RxrmYfEm1Maq8byoLXUr5RfXcwgqpCcAq5enMnl9V9E=";

  subPackages = [ "cmd/norouter" ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/norouter --version | grep ${version} > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    # Doesn't build with Go >=1.21
    # https://github.com/norouter/norouter/issues/165
    broken = true;
    description = "Tool to handle unprivileged networking by using multiple loopback addresses";
    homepage = "https://github.com/norouter/norouter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ blaggacao ];
    mainProgram = "norouter";
  };
}
