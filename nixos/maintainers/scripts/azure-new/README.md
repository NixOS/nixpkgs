# azure

## Demo

Here's a demo of this being used: https://asciinema.org/a/euXb9dIeUybE3VkstLWLbvhmp

## Usage

Build and upload the image
```shell
$ ./upload-image.sh ./examples/basic/image.nix

...
+ attr=azbasic
+ nix-build ./examples/basic/image.nix --out-link azure
/nix/store/qdpzknpskzw30vba92mb24xzll1dqsmd-azure-image
...
95.5 %, 0 Done, 0 Failed, 1 Pending, 0 Skipped, 1 Total, 2-sec Throughput (Mb/s): 932.9565 
...
/subscriptions/aff271ee-e9be-4441-b9bb-42f5af4cbaeb/resourceGroups/nixos-images/providers/Microsoft.Compute/images/azure-image-todo-makethisbetter
```

Take the output, boot an Azure VM:

```
img="/subscriptions/.../..." # use output from last command
./boot-vm.sh "${img}"
...
=> booted
```
