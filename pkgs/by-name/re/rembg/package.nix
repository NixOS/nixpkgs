{ python3Packages }:

python3Packages.toPythonApplication (python3Packages.rembg.override { withCli = true; })
