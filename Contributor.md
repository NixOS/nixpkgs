# A code that might end up your computer's memory
# Ackerman function
SOURCE CODE : :
```c
/* C Program to implement Ackermann function using recursion */

#include<stdio.h>
int A(int m, int n);

main()
{
	int m,n;
	printf("Enter two numbers :: \n");
	scanf("%d%d",&m,&n);
	printf("\nOUTPUT :: %d\n",A(m,n));
}

int A(int m, int n)
{
	if(m==0)
		return n+1;
	else if(n==0)
		return A(m-1,1);
	else
		return A(m-1,A(m,n-1));
}
```

>we may notice the use of Ackerman  
>in minimum spanning trees  
>and disjoint set forest construction. 
