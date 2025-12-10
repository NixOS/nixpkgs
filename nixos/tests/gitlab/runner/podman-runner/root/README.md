# Content

These are some files which are copied to the image in the runner needed for
`buildah` (`podman`):

```bash
podman create --name temp-buildah quay.io/buildah/stable:latest
podman cp temp-buildah:/etc/containers ./etc/
find ./etc -type d -empty -delete
podman container rm temp-buildah
```
