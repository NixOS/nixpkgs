{
  pkgs,
  runTest,
  ...
}:

let
  testEtcd =
    path: oPkgs:
    runTest (
      let
        etcdPkgs = pkgs // oPkgs;
      in
      pkgs.lib.recursiveUpdate {
        meta = {
          maintainers = etcdPkgs.etcd.meta.maintainers;
          platforms = [
            "aarch64-linux"
            "x86_64-linux"
          ];
        };
      } (import path etcdPkgs)
    );
  testEtcdPkg = pkg: path: testEtcd path { etcd = pkg; };
  testEtcd_3_4 = testEtcdPkg pkgs.etcd_3_4;
  testEtcd_3_5 = testEtcdPkg pkgs.etcd_3_5;
  testEtcd_3_6 = testEtcdPkg pkgs.etcd_3_6;
in

{
  "3_4" = {
    multi-node = testEtcd_3_4 ./multi-node.nix;
    single-node = testEtcd_3_4 ./single-node.nix;
  };
  "3_5" = {
    multi-node = testEtcd_3_5 ./multi-node.nix;
    single-node = testEtcd_3_5 ./single-node.nix;
  };
  "3_6" = {
    multi-node = testEtcd_3_6 ./multi-node.nix;
    single-node = testEtcd_3_6 ./single-node.nix;
  };
}
