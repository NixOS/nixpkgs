# Building a Bun project with nix

[Here](../../test/bun/default.nix) is a very simple example of how to package a hono service in bun:
```nix
pkgs.buildBunModules {
  pname = "bun-hono-example";
  version = "1.0.87";
  vendorSha256 = "sha256-ne/9TOoH69/DAtbR0vzEMWy2yTc3F2mRJsOU7ANEGLs=";
  src = ./.;
}

```
Obviously `pname`, `version` and `src` are mandatory, where `vendorSha256` is the calculated hash of `node_modules`, left this empty if don't wish to verify vendor packages' integrity by nix, e.g. if you have `bun.lockb` already, which verify and lock all packages.

Other optional attributes you can provide are:
- `prod`: default to `true`, only install production dependencies using `bun install --production`, otherwise install all dependencies.
- `bunlock`: default to `src + "./bun.lockb"`, please specify if you have bunlock in other location.

Run the test:
```
nix-build -A tests.bun
./result/bin/bun-hono-example start
```
