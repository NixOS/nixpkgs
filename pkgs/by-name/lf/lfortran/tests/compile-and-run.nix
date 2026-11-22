{ runCommand, lfortran }:

runCommand "${lfortran.pname}-test-compile"
  {
    nativeBuildInputs = [ lfortran ];
  }
  ''
    cat << 'EOF' > hello.f90
    program hello
      print *, "Hello from LFortran!"
    end program hello
    EOF
    lfortran hello.f90 -o hello
    ./hello | grep -F "Hello from LFortran!"
    touch $out
  ''
