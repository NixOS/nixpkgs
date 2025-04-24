{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "jjui";
  version = "0-unstable-2024-12-10";

  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    rev = "525c8042a51710cdaefa91176af68a22ad0045bd";
    hash = "sha256-WSlcJFLOe5UVvWubSPP391+AxepEa5M6GpmZnjYMjww=";
  };

  vendorHash = "sha256-kg5b3tzwyAhn00GwdUDf4OdYZvCJZHgkgpzHFWy5SxI=";

  postFixup = ''
    mv $out/bin/cmd $out/bin/jjui
  '';

  meta = {
    description = "A TUI for Jujutsu VCS";
    homepage = "https://github.com/idursun/jjui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "jjui";
  };
}
