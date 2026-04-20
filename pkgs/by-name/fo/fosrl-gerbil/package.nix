{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gerbil";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = finalAttrs.version;
    hash = "sha256-liz1v0vMYH9AbGmKHZV7IBYBAT8fkjUsGzNqRXYDmpU=";
  };

  vendorHash = "sha256-NtyU/zKysl9h0wqOtwizrOAJK5ODIc8ZvVtbkogBhm8=";

  # patch out the /usr/sbin/iptables
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail '/usr/sbin/iptables' '${lib.getExe iptables}'
  '';

  meta = {
    description = "Simple WireGuard interface management server";
    mainProgram = "gerbil";
    homepage = "https://github.com/fosrl/gerbil";
    changelog = "https://github.com/fosrl/gerbil/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    platforms = lib.platforms.linux;
  };
})
