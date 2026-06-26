{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bhash";
  version = "1.0.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aluoty";
    repo = "bhash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ebQGTTAam5tCpo7azvWstblouZS34YcrNvEu3UkYy+k=";
  };

  nativeBuildInputs = [
    zig
  ];

  meta = {
    description = "Hashing utility built using Zig";
    homepage = "https://github.com/aluoty/bhash";
    changelog = "https://github.com/aluoty/bhash/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "bhash";
    maintainers = with lib.maintainers; [ aluoty ];
    inherit (zig.meta) platforms;
  };
})
