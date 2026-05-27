{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "matter_compiler";
  gemdir = ./.;
  exes = [ "matter_compiler" ];

  passthru.updateScript = bundlerUpdateScript "matter-compiler";

  meta = {
    description = ''
      Matter Compiler is a API Blueprint AST Media Types to API Blueprint conversion tool.
      It composes an API blueprint from its serialzed AST media-type.
    '';
    homepage = "https://github.com/apiaryio/matter_compiler/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rvlander
      nicknovitski
    ];
    platforms = lib.platforms.unix;
  };
}
