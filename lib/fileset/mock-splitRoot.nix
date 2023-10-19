# This overlay implements mocking of the lib.path.splitRoot function
# It pretends that the last component named "mock-root" is the root:
#
# splitRoot /foo/mock-root/bar/mock-root/baz
# => {
#      root = /foo/mock-root/bar/mock-root;
#      subpath = "./baz";
#    }
self: super: {
  path = super.path // {
    splitRoot = path:
      let
        parts = super.path.splitRoot path;
        components = self.path.subpath.components parts.subpath;
        count = self.length components;
        rootIndex = count - self.lists.findFirstIndex
          (component: component == "mock-root")
          (self.length components)
          (self.reverseList components);
        root = self.path.append parts.root (self.path.subpath.join (self.take rootIndex components));
        subpath = self.path.subpath.join (self.drop rootIndex components);
      in {
        inherit root subpath;
      };
  };
}
