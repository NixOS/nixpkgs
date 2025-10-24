{ python3Packages }: with python3Packages; toPythonApplication (rembg.override { withCli = true; })
