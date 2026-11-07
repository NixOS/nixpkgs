{ runCommand, lfortran }:

# `lfortran -g` post-processes the executable with llvm-dwarfdump and Python
# scripts, all of which must be found at runtime.
runCommand "${lfortran.pname}-test-debug-info"
  {
    nativeBuildInputs = [ lfortran ];
  }
  ''
    cat << 'EOF' > hello.f90
    program hello
      print *, "Hello from LFortran!"
    end program hello
    EOF
    lfortran -g hello.f90 -o hello
    ./hello | grep -F "Hello from LFortran!"
    touch $out
  ''
