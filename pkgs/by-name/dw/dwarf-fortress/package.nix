{
  dwarf-fortress-packages,
  ...
}@args:

# The latest Dwarf Fortress with the default wrapper; see default.nix.
# Override arguments are passed on to the wrapper.
dwarf-fortress-packages.dwarf-fortress.override (removeAttrs args [ "dwarf-fortress-packages" ])
