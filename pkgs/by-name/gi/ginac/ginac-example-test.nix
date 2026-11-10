{
  runCommand,
  gccStdenv,
  cln,
  ginac,
}:
runCommand "ginac-example-test"
  {
    nativeBuildInputs = [
      gccStdenv.cc
      ginac
      cln
    ];
  }
  ''
    echo "
      #include <iostream>
      #include <ginac/ginac.h>
      using namespace std;
      using namespace GiNaC;

      int main() {
        symbol x(\"x\"), y(\"y\");
        ex poly;

        for (int i=0; i<3; ++i) {
          poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
        }

        cout << poly << endl;
        return 0;
      }" > hello.cc
    c++ -lginac -lcln hello.cc -o hello
    ./hello
    mkdir $out
  ''
