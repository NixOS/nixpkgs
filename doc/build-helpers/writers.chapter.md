# Writers {#chap-writers}

The `pkgs.writers` helpers let you write a small Python script directly inside a Nix expression. You provide a script as text, and it builds a ready to run program for you.

They do two useful things:

- If your script needs a library, the writer makes it available, so you don't have to install anything or use `nix-shell`.
- Before finishing, the writer checks your script with `flake8`. If something is wrong, the build fails, so a broken script never gets built.

They are meant for short scripts. For real programs made of many files, use [`buildPythonApplication`](#buildpythonapplication-function) instead.

## Python writers {#ssec-writers-python}

There are two writers, and each has a `Bin` version:

- `writePython3` gives you the script itself. `writePyPy3` is the same but uses PyPy.
- `writePython3Bin` gives you a small package with the program in a `bin/` folder, ready to add to `PATH`.

Each one takes a name, a set of options, and the script. The options are:

`libraries` (default: none)
:   The packages your script needs to import, like `[ pkgs.python3Packages.pyyaml ]`.

`flakeIgnore` (default: none)
:   [`flake8` warnings](https://flake8.pycqa.org/en/latest/user/error-codes.html) to ignore, like `[ "E501" ]` for long lines.

`doCheck` (default: `true`)
:   Set to `false` to turn off the `flake8` check.

:::{.example #ex-writers-writePython3Bin}
# A Python 3 program that uses a library

```nix
writePython3Bin "whatsmyip"
  {
    libraries = [ pkgs.python3Packages.requests ];
  }
  ''
    import requests

    resp = requests.get("https://api.ipify.org?format=json", timeout=10)
    print("your public IP is:", resp.json()["ip"])
  ''
```

This builds `bin/whatsmyip`. The script can `import requests` because the writer set Python up with that library. You would run this using: `nix-build writers-test.nix`
