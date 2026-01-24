self: super:
with self;
lib.mkIf config.allowAliases {
  autopair-fish = self.autopair; # Added 2023-03-10
}
