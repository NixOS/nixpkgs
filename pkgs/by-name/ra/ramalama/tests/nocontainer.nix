{
  callPackage,
  ramalama,
}:

(callPackage ./common.nix { inherit ramalama; }).mkServeTest {
  name = "ramalama-nocontainer-test";
  port = 18080;
  model = callPackage ./llama-cpp-model.nix { };
  nocontainer = true;
}
