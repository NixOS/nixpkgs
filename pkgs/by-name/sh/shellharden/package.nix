{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shellharden";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = "shellharden";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-brDqAxY36dl0xSDgzovq/mqvw3eRy+vkuLQozqPsDlc=";
  };

  cargoHash = "sha256-RE1k9G3xKTJ0F79bKrhgS+5O30eqVnA3iLCc+CHfS2Y=";

  postPatch = "patchShebangs moduletests/run";

  meta = {
    description = "Corrective bash syntax highlighter";
    mainProgram = "shellharden";
    longDescription = ''
      Shellharden is a syntax highlighter and a tool to semi-automate the
      rewriting of scripts to ShellCheck conformance, mainly focused on quoting.
    '';
    homepage = "https://github.com/anordal/shellharden";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
})
