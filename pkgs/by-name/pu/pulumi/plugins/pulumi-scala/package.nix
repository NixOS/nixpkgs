{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "pulumi-scala";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "VirtusLab";
    repo = "besom";
    tag = "v${version}";
    hash = "sha256-iJLIwc8yVURz7YdL42hJBfvYNpaehJbPIAB51umsLEE=";
  };

  sourceRoot = "source/language-plugin/pulumi-language-scala";
  vendorHash = "sha256-GGkHKLKtcx/uW9CvrFIFKr2sZD3Mx0RYQM3lI9HvMXY=";

  postInstall = ''
    mv $out/bin/language-host $out/bin/${meta.mainProgram}
  '';

  meta = {
    description = "Besom - a Pulumi SDK for Scala. Also, incidentally, a broom made of twigs tied round a stick. Brooms and besoms are used for protection, to ward off evil spirits, and cleansing of ritual spaces";
    homepage = "https://github.com/VirtusLab/besom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nikolaiser ];
    mainProgram = "pulumi-language-scala";
    platforms = lib.platforms.all;
  };
}
