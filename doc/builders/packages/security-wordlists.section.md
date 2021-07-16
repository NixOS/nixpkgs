# Security Wordlists {#security-Wordlists}

The `security-wordlists` package, defined in [pkgs/tools/security/wordlists/](https://github.com/NixOS/nixpkgs/blob/master/pkgs/tools/security/wordlists/), allows to install and access popular security lists of words.
It can be configured to specify which ones to include.

## Usage

### In a shell

Commonly, it can be used with the following:

- Get a shell with the `security-wordlists` package including the `nmap` and `rockyou` wordlists.
```bash
nix-shell -p 'security-wordlists.withLists(ps: with ps; [ nmap rockyou ])'
```
- Two commands are available in this shell:
  - `wordlists`, to spell out the available wordlists and their location in the store
  ```bash
  [nix-shell:~]$ wordlists
  /nix/store/<HASH>-wordlists-unstable-2020-11-23/share
  └── nmap.lst -> /nix/store/<HASH>-nmap.lst-unstable-2020-10-19/share/nmap.lst
  └── rockyou.txt -> /nix/store/y1521i0h8pfkdkv1c91fdp76g49kwki8-rockyou-0.3-1kali3/share/rockyou.txt

  0 directories, 2 files
  ```
  - `wordlists_path`, to print the store location where the included lists are bundled
  ```bash
  [nix-shell:~]$ wordlists_path
  /nix/store/<HASH>-wordlists-unstable-2020-11-23/share

  [nix-shell:~]$ cat "$(wordlists_path)/nmap.lst"
  [... content of nmap.lst ...]
  ```

### In an expression

The different security wordlists available can themselves individually be imported inside a nix expression.
For example:

```nix
with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "example";

  buildInputs = with security-wordlists.pkgs; [ nmap rockyou ];

  # [...]
}
```

## Help

### List the available wordlists

```nix
# list_wordlists.nix
with import <nixpkgs> {};

let
  scopeAttrs = builtins.attrNames (stdenv.lib.makeScope pkgs.newScope(_: {}));
in
  builtins.attrNames (
    builtins.removeAttrs pkgs.security-wordlists.pkgs scopeAttrs
  )
```

```bash
nix-instantiate --eval list_wordlists.nix
```
