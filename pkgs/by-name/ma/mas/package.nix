{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  testers,
  mas,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mas";
  version = "1.8.6";

  src = fetchurl {
    # Use the tarball until https://github.com/mas-cli/mas/issues/452 is fixed.
    # Even though it looks like an OS/arch specific build it is actually a universal binary.
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas-${version}.monterey.bottle.tar.gz";
    sha256 = "0q4skdhymgn5xrwafyisfshx327faia682yv83mf68r61m2jl10d";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    install -D './${version}/bin/mas' "$out/bin/mas"
    installShellCompletion --cmd mas --bash './${version}/etc/bash_completion.d/mas'
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = mas;
      command = "mas version";
    };
  };

  meta = with lib; {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = licenses.mit;
    maintainers = with maintainers; [
      steinybot
      zachcoyle
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
