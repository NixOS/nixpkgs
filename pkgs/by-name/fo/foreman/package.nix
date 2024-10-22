{ bundlerEnv, lib, ruby }:

bundlerEnv {
  inherit ruby;
  pname = "foreman";
  gemdir = ./.;

  meta = with lib; {
    description = "Process manager for applications with multiple components";
    homepage = "https://github.com/ddollar/foreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = ruby.meta.platforms;
    mainProgram = "foreman";
  };
}
