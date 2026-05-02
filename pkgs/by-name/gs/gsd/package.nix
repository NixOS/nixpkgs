{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  makeWrapper,
  fd,
  ripgrep,
  gh,
}:

buildNpmPackage (finalAttrs: {
  pname = "gsd";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "gsd-build";
    repo = "gsd-2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GZQgFa8zLbEpc8QzyxSX9nJpafpjgiH8DC9z/g7JLDc=";
  };

  npmDepsHash = "sha256-8nLlPsOfMH7+vm7TStKXfh9CwRly7sL+Sr1hrkGKhfM=";

  nodejs = nodejs_22;

  nativeBuildInputs = [ makeWrapper ];

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  postFixup = ''
    wrapProgram $out/bin/gsd \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          ripgrep
          gh
        ]
      }
    wrapProgram $out/bin/gsd-cli \
      --prefix PATH : ${
        lib.makeBinPath [
          fd
          ripgrep
          gh
        ]
      }
  '';

  meta = {
    description = "A powerful meta-prompting, context engineering and spec-driven development system that enables agents to work for long periods of time autonomously without losing track of the big picture";
    homepage = "https://github.com/gsd-build/gsd-2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ otavio ];
    mainProgram = "gsd";
  };
})
