# Interactive shell helpers {#sec-shell-helpers}

Some packages provide shell integration to be more useful. But unlike other systems, nix doesn't have a standard `share` directory location. This is why a bunch of `PACKAGE-share` scripts are shipped that print the location of the corresponding shared folder. The current list of such packages is as follows:

- `fzf` : `fzf-share`

E.g. `fzf` can then be used in the `.bashrc` like this:

```bash
source "$(fzf-share)/completion.bash"
source "$(fzf-share)/key-bindings.bash"
```
