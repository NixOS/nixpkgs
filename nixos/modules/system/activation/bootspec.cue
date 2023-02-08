#V1: {
	system:         string
	init:           string
	initrd?:        string
	initrdSecrets?: string
	kernel:         string
	kernelParams: [...string]
	label:    string
	toplevel: string
	specialisation?: {
		[=~"^"]: #V1
	}
	extensions?: {...}
}

Document: {
	v1: #V1
}
