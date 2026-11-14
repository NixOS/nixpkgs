{
  bundlerEnv,
  lib,
  ruby,
}:

bundlerEnv {
  inherit ruby;
  pname = "foreman";
  gemdir = ./.;

  meta = {
    description = "Process manager for applications with multiple components";
    homepage = "https://github.com/ddollar/foreman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
    mainProgram = "foreman";
  };
}
