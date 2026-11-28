{ stdenv }:
stdenv.mkDerivation {
  name = "jobserver-probe";
  buildCommand = ''
    {
      echo "MAKEFLAGS=''${MAKEFLAGS-<unset>}"
      echo "NIX_BUILD_CORES=$NIX_BUILD_CORES"
      if [ -c /dev/steve ]; then
        echo "DEVICE=character"
      else
        echo "DEVICE=missing"
      fi
    } > "$out"

    # Drain the pool to prove the device serves tokens inside the sandbox.
    if [ -c /dev/steve ]; then
      n=0
      while [ "$n" -lt 64 ] && IFS= read -r -n1 -t 1 _tok < /dev/steve; do
        n=$((n + 1))
      done
      echo "TOKENS=$n" >> "$out"
    fi
  '';
}
