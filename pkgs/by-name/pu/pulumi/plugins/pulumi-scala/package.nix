{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pulumi-scala";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "VirtusLab";
    repo = "besom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5xGg+8oQBmjO6oHCsTjIlQQar/xd/n1ouzfArj2vh70=";
  };

  sourceRoot = "source/language-plugin/pulumi-language-scala";
  vendorHash = "sha256-BFY77GGTW9GaNG93OSJrr3CPRe5JQhxDhqNPuv/ouuw=";

  postInstall = ''
    mv $out/bin/language-host $out/bin/${finalAttrs.meta.mainProgram}
  '';

  meta = {
    description = "Besom - a Pulumi SDK for Scala. Also, incidentally, a broom made of twigs tied round a stick. Brooms and besoms are used for protection, to ward off evil spirits, and cleansing of ritual spaces";
    homepage = "https://github.com/VirtusLab/besom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nikolaiser ];
    mainProgram = "pulumi-language-scala";
    platforms = lib.platforms.all;
  };
})
