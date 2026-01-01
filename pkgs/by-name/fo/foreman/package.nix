{
  bundlerEnv,
  lib,
  ruby,
}:

bundlerEnv {
  inherit ruby;
  pname = "foreman";
  gemdir = ./.;

<<<<<<< HEAD
  meta = {
    description = "Process manager for applications with multiple components";
    homepage = "https://github.com/ddollar/foreman";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
=======
  meta = with lib; {
    description = "Process manager for applications with multiple components";
    homepage = "https://github.com/ddollar/foreman";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = ruby.meta.platforms;
    mainProgram = "foreman";
  };
}
