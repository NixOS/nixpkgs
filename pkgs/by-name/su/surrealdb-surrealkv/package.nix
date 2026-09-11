{
  _surrealdbPackage,
  callPackage,
}:
callPackage _surrealdbPackage {
  backend = "surrealkv";
}
