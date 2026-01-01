package main

import (
	"fmt"
	"io"
<<<<<<< HEAD
	"os"
	"github.com/docker/docker/daemon/builder/remotecontext/tarsum"
=======
	"io/ioutil"
	"os"
	"github.com/docker/docker/pkg/tarsum"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
)

func main() {
	ts, err := tarsum.NewTarSum(os.Stdin, true, tarsum.Version1)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

<<<<<<< HEAD
	if _, err = io.Copy(io.Discard, ts); err != nil {
=======
	if _, err = io.Copy(ioutil.Discard, ts); err != nil {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(ts.Sum(nil))
}
