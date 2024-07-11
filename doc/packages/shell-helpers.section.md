# Interactive shell helpers {#sec-shell-helpers}

Some packages provide the shell integration to be more useful. But unlike other systems, nix doesn't have a standard `share` directory location. This is why a bunch `PACKAGE-share` scripts are shipped that print the location of the corresponding shared folder. Current list of such packages is as following:

- `fzf` : `fzf-share`

E.g. `fzf` can then be used in the `.bashrc` like this:

```bash
source "$(fzf-share)/completion.bash"
source "$(fzf-share)/key-bindings.bash"
```
