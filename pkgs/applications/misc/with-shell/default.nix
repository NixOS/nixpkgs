{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "with";
  version = "unstable-2018-03-20";

  src = fetchFromGitHub {
    owner = "mchav";
    repo = "With";
    rev = "28eb40bbc08d171daabf0210f420477ad75e16d6";
    hash = "sha256-mKHsLHs9/I+NUdb1t9wZWkPxXcsBlVWSj8fgZckXFXk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -D with $out/bin/with
    installShellCompletion --bash --name with.bash with.bash-completion
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/mchav/With";
    description = "Command prefixing for continuous workflow using a single tool";
    longDescription = ''
      with is a Bash script that starts an interactive shell with where every
      command is prefixed using <program>.

      For example:

      $ with git
      git> add .
      git> commit -a -m "Committed"
      git> push

      Can also be used for compound commands.

      $ with java Primes
      java Primes> 1
      2
      java Primes> 4
      7

      And to repeat commands:

      $ with gcc -o output input.c
      gcc -o -output input.c>
      <enter>
      Compiling...
      gcc -o -output input.c>

      To execute a shell command proper prefix line with :.

      git> :ls

      You can also drop, add, and replace different commands.

      git> +add
      git add> <some file>
      git add> !commit
      git commit> <arguments and message>
      git commit> -
      git>

      To exit use either :q or :exit.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    mainProgram = "with";
  };
}
