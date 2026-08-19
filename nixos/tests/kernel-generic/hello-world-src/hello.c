// SPDX-License-Identifier: MIT
#include <linux/module.h>
#include <linux/printk.h>

static int hello(void)
{
	pr_info("Hello world!");
	return 0;
}
module_init(hello);

static void goodbye(void)
{
	pr_info("Goodbye");
}
module_exit(goodbye);

MODULE_LICENSE("MIT");
