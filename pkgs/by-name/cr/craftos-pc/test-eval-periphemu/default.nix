{
  stdenv,
  craftos-pc,
  gnugrep,
}:
stdenv.mkDerivation {
  name = "craftos-pc-test-eval-periphemu";
  meta.timeout = 60;
  nativeBuildInputs = [
    craftos-pc
    gnugrep
  ];
  buildCommand = ''
    export HOME=$(pwd)
    mkdir $HOME/.local $HOME/.config
    export XDG_CONFIG_DIR=$HOME/.config
    export XDG_DATA_DIR=$HOME/.local
    if craftos --headless --script ${./init.lua} | grep -q "FAIL"; then
        exit 1
    fi
    touch $out
  '';
}
