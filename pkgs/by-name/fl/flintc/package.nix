{
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flintc";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "flint-lang";
    repo = "flintc";
    tag = "v${finalAttrs.version}-core";
    sha256 = "75fcedf31ccacd26733ed5a5ae19b6ab410ce3aa256bcf79ed8678d8362897a4";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  strictDeps = true;
  __structuredAttrs = true;


  meta = with lib; {
    description = "Flint programming language compiler and language server";
    homepage = "https://github.com/flint-lang/flintc";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zweiler1 ];
    mainProgram = "flintc";
  };
})
